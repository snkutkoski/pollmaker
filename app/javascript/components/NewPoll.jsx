import React from 'react'
import PollForm from './PollForm'
import axios from 'axios'

export default class NewPoll extends React.Component {
  static getCompletedOptions (options) {
    return options.filter((option) => (option.name.length > 0))
  }

  static submit ({question, options}) {
    const completedOptions = NewPoll.getCompletedOptions(options)
    axios.post('/polls', {poll: {question: question, options: completedOptions}})
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
      <PollForm onSubmit={NewPoll.submit} validate={NewPoll.validate} />
    )
  }
}
