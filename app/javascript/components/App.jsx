import React from 'react'
import NewPoll from './NewPoll'
import Poll from './Poll'
import { BrowserRouter as Router, Route, Switch } from 'react-router-dom'

const App = () => (
  <div className="container">
    <Router>
      <Switch>
        <Route path="/poll/:id" component={Poll} />
        <Route path="/" component={NewPoll} />
      </Switch>
    </Router>
  </div>
)

export default App
