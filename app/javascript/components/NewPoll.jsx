import React from 'react'
import PollForm from './PollForm'
import axios from 'axios'
import { withRouter } from 'react-router-dom'

class NewPoll extends React.Component {
  constructor(props) {
    super(props)

    this.submit = this.submit.bind(this)
  }

  static getCompletedOptions (options) {
    return options.filter((option) => (option.name.length > 0))
  }

  submit ({question, options}) {
    const completedOptions = NewPoll.getCompletedOptions(options)
    axios.post('/polls', {poll: {question: question, options: completedOptions}})
      .then(({data}) => {
        this.props.history.push(`/poll/${data.id}`)
      })
  }

  static validate ({question, options}) {
    const errors = {}
    const completedOptions = NewPoll.getCompletedOptions(options)
    if (completedOptions.length < 2) {
      errors.options = {_error: 'Two or more options are required'}
    }

    if (!question || question.length < 1) {
      errors.question = 'Question is required'
    }

    return errors
  }

  render() {
    return (
      <PollForm onSubmit={this.submit} validate={NewPoll.validate} />
    )
  }
}

export default withRouter(({history}) =>
  <NewPoll history={history} />
)
