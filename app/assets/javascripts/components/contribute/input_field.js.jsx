var InputField = React.createClass({
  inputStyle: {
    'marginBottom':'1em'
  },
  render: function() {
    return <ul>
      <li>
        <input style={this.inputStyle} className='form-control'type='text' name="contribution[other_authors][]">
        </input>
      </li>
      <li>
        <button type="button" className='btn' onClick={ this.props.remove }>
          <i className="glyphicon glyphicon-remove"></i>
        </button>
      </li>
    </ul>
  }
})
