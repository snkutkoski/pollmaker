import React from 'react'
import { Field, FieldArray, reduxForm } from 'redux-form'

const renderField = ({input, key, label, type, meta: {touched, error}}) => (
  <div key={key} className="form-group">
    {label && <label>{label}</label>}
    <input {...input} placeholder={label} type={type} className="form-control"/>
    {touched && error && <span style={{color: 'red'}}>{error}</span>}
  </div>
)

const renderOptions = ({ fields, meta: { error, submitFailed } }) => (
  <div>
    {submitFailed && error && <span style={{color: 'red'}}>{error}</span>}

    {fields.map((option, index) => {
      return (
        <div key={index} className="form-group">
          <Field name={`${option}name`} type="text" component={renderField} label={`Option ${index + 1}`} key={index}/>
          {index >= 2 && <button className='btn btn-sm btn-danger' type="button" onClick={() => fields.remove(index)}>Remove Option</button>}
        </div>
      )
    })}

    <div className="form-group">
      <button className="btn btn-sm btn-success" type="button" onClick={() => fields.push({name: ''})}>
        Add Option
      </button>
    </div>
  </div>
)

let PollForm = props => {
  const {handleSubmit} = props
  return (
    <form onSubmit={handleSubmit}>
      <Field name="question" component={renderField} label='Question' type='text' />

      <FieldArray name="options" component={renderOptions} />

      <div className="form-group">
        <button type="submit" className="btn btn-primary">Submit</button>
      </div>
    </form>
  )
}

PollForm = reduxForm({
  form: 'new-poll',
  initialValues: {
    options: [{name: ''}, {name: ''}]
  }
})(PollForm)

export default PollForm