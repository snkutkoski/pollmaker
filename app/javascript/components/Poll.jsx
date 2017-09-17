import React from 'react'
import axios from 'axios'
import VoteForm from './VoteForm'

export default class Poll extends React.Component {
  constructor (props) {
    super(props)

    this.handleOptionSelect = this.handleOptionSelect.bind(this)
    this.castVote = this.castVote.bind(this)

    this.state = {hasVoted: false, selectedOption: null}
  }

  componentDidMount () {
    axios.get(`/polls/${this.props.match.params.id}`)
      .then(({data}) => {
        const options = data.options.map((option) => {
          return {name: option.name, vote_count: option.vote_count, id: option.id}
        })
        this.setState({poll: {
          id: data.id,
          question: data.question,
          options: options
        }})
      })
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
        <div>
          <h4>{this.state.poll.question}</h4>
          <VoteForm options={this.state.poll.options}
                    hasVoted={this.state.hasVoted}
                    selectedOption={this.state.selectedOption}
                    handleOptionSelect={this.handleOptionSelect}
                    castVote={this.castVote}
          />
        </div>
      )
    } else {
      return <div>Loading...</div>
    }
  }
}
