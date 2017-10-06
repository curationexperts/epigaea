var ContributeOtherAuthors = React.createClass({
  removeStyle: {
    'display':'inline',
    'marginLeft':'.5em'
  },
  addStyle: {
    'marginBottom': '1em'
  },
  getInitialState() {
    return { inputs: [] }
  },
  render: function() {
    var inputs = this.state.inputs.map((Element, index) => {
      return <Element key={ index } index={ index } remove={this.remove} />
    })

    return <div>
  <div className="inputs">
    <label>Other Authors</label>
    { inputs }
  </div>
  <button type="button" style={this.addStyle} className='btn btn-primary' onClick={ this.add }>Add Another Author</button>
  
    </div>
  },
  add: function() {
    var inputs = this.state.inputs.concat(InputField)  
    this.setState({inputs})
  },
  remove(e) {
    var array = this.state.inputs;
    var index = array.indexOf(e.target.value)
    array.splice(index, 1)
    this.setState({ array })
  }
})
