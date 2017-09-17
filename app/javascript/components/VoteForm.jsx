import React from 'react'

export default class VoteForm extends React.Component {
  constructor (props) {
    super(props)
  }

  renderOptions () {
    return this.props.options.map((option, index) => {
      return (
        <div key={index} className="radio">
          <label>
            <input type="radio"
                   name="option"
                   onClick={() => this.props.handleOptionSelect(option.id)}
                   disabled={this.props.hasVoted}
                   checked={option.id === this.props.selectedOption} />
            {option.name}
          </label>
        </div>
      )
    })
  }

  render () {
    return (
      <div>
        {this.renderOptions()}
        <button className="btn btn-primary" onClick={this.props.castVote} disabled={this.props.hasVoted}>Vote</button>
      </div>
    )
  }
}
