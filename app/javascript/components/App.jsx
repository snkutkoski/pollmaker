import React from 'react'
import NewPoll from './NewPoll'
import Poll from './Poll'
import { BrowserRouter as Router, Route, Switch } from 'react-router-dom'

const App = (props) => (
  <div className="container">
    <h2>Pollmaker</h2>
    <Router>
      <Switch>
        <Route path="/poll/:id" component={Poll} />
        <Route path="/" component={NewPoll} />
      </Switch>
    </Router>
  </div>
)

export default App
