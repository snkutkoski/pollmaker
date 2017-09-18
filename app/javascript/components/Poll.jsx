import React from 'react'
import axios from 'axios'
import VoteForm from './VoteForm'
import Results from './Results'
import ActionCable from 'actioncable'
import { withCookies } from 'react-cookie'

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

class Poll extends React.Component {
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
        const votedPolls = this.getVotedPolls(this.props.cookies)
        const hasVoted = !!(votedPolls.find((poll_id) => (poll_id === data.id)))

        this.setState({poll: buildPoll(data), hasVoted: hasVoted})
      })

    const host = window.location.hostname
    const port = window.location.port
    const protocol = window.location.protocol === 'https:' ? 'wss' : 'ws'
    this.cable = ActionCable.createConsumer(`${protocol}://${host}:${port}/cable`);

    this.cable.subscriptions.create(
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
      .then(() => {
        const cookies = this.props.cookies
        const votedPolls = this.getVotedPolls(cookies)
        votedPolls.push(this.state.poll.id)
        cookies.set('voted_polls', votedPolls, {path: '/'})
      })
  }

  getVotedPolls(cookies) {
    let votedPolls = cookies.get('voted_polls')
    return Array.isArray(votedPolls) ? votedPolls : []
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

export default withCookies(Poll)
