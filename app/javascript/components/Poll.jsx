import React from 'react'
import axios from 'axios'
import VoteForm from './VoteForm'
import Results from './Results'
import ActionCable from 'actioncable'

const buildPoll = (data) => {
  const options = data.options.map((option) => {
    return {name: option.name, vote_count: option.vote_count, id: option.id}
  })

  return {
    id: data.id,
    question: data.question,
    options: options
  }
}

export default class Poll extends React.Component {
  constructor (props) {
    super(props)

    this.handleOptionSelect = this.handleOptionSelect.bind(this)
    this.castVote = this.castVote.bind(this)
    this.handleVoteReceived = this.handleVoteReceived.bind(this)

    this.state = {hasVoted: false, selectedOption: null}
  }

  handleVoteReceived(data) {
    this.setState({poll: buildPoll(data.poll)})
  }

  componentDidMount () {
    axios.get(`/polls/${this.props.match.params.id}`)
      .then(({data}) => {
        this.setState({poll: buildPoll(data)})
      })

    this.cable = ActionCable.createConsumer('ws://localhost:3000/cable');

    this.operations = this.cable.subscriptions.create(
      {channel: 'PollChannel', id: this.props.match.params.id},
      {received: this.handleVoteReceived}
    )
  }

  handleOptionSelect (optionId) {
    this.setState({selectedOption: optionId})
  }

  castVote () {
    // Set hasVoted before the http request so that users cannot submit twice
    this.setState({hasVoted: true})
    axios.post(`/options/${this.state.selectedOption}/vote`)
  }

  render () {
    if (this.state.poll) {
      return (
        <div className="row">
          <div className="col-sm-6">
            <h4>{this.state.poll.question}</h4>
            <VoteForm options={this.state.poll.options}
                      hasVoted={this.state.hasVoted}
                      selectedOption={this.state.selectedOption}
                      handleOptionSelect={this.handleOptionSelect}
                      castVote={this.castVote}
            />
          </div>
          {
            this.state.hasVoted &&
            <div className="col-sm-6">
              <Results options={this.state.poll.options}/>
            </div>
          }
        </div>
      )
    } else {
      return <div>Loading...</div>
    }
  }
}
