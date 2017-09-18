import React from 'react'

export default class Results extends React.Component {
  constructor(props) {
    super(props)
  }

  render () {
    const sortedOptions = this.props.options.sort((o1, o2) => o2.vote_count - o1.vote_count)

    const results = sortedOptions.map((option, index) => (
      <tr key={index}>
        <td>{option.name}</td>
        <td>{option.vote_count}</td>
      </tr>
    ))
    return (
      <table className="table">
        <thead>
          <tr>
            <th>Option</th>
            <th>Votes</th>
          </tr>
        </thead>
        <tbody>
          {results}
        </tbody>
      </table>
    )
  }
}
