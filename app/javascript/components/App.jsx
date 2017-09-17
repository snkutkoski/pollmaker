import React from 'react'
import NewPoll from './NewPoll'
import { BrowserRouter as Router, Route } from 'react-router-dom'

const App = () => (
  <div className="container">
    <Router>
      <Route path="/" component={NewPoll} />
    </Router>
  </div>
)

export default App
