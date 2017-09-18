import React from 'react'
import ReactDOM from 'react-dom'
import { Provider } from 'react-redux'
import { createStore, combineReducers } from 'redux'
import App from '../components/App'
import { reducer as formReducer } from 'redux-form'
import axios from 'axios'
import { CookiesProvider } from 'react-cookie'

const store = createStore(combineReducers({form: formReducer}),
  window.__REDUX_DEVTOOLS_EXTENSION__ && window.__REDUX_DEVTOOLS_EXTENSION__())

const token = document.getElementsByName('csrf-token')[0].getAttribute('content')
axios.defaults.headers.common['X-CSRF-Token'] = token
axios.defaults.headers.common['Accept'] = 'application/json'

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <Provider store={store}>
      <CookiesProvider>
        <App/>
      </CookiesProvider>
    </Provider>,
    document.body.appendChild(document.createElement('div')),
  )
})
