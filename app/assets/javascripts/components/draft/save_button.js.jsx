var DraftSaveButton = React.createClass ({
    getInitialState: function() {
        var draftState = {
            isSaved:this.props.draftSaved,
            error:false,
            isSaving:false
        }
        return draftState
    },
    render: function () {
        return <ul className='drafts'>
        <li className='draft-button'>
        <button type='button' className='btn btn-primary' onClick={this.saveDraft}>Save Draft
        { this.state.isSaving && <DraftIsSaving /> }
        </button>
        </li>
        <li className='draft-button'>
        <button  type='button' className='btn btn-default' onClick={this.revertDraft} disabled={!this.state.isSaved}>Revert Draft</button>
        </li>
        { !this.state.isSaved && <DraftWorkflowStatusPublished /> }
        { this.state.isSaved && <DraftWorkflowStatusEdited /> }
        { this.state.error && <DraftError/> }
        </ul>
    },
    isSaved: function() {
        // Check to see if the work has a saved draft
        var draftSaveButton = this
        $.get('/draft/draft_saved/' + draftSaveButton.props.curationConcernId, function(data) {
            if (data.status) {
                draftSaveButton.setState({isSaved: true})
            } else {
                draftSaveButton.setState({isSaved: false})
            }
        }).fail(function() {
            draftSaveButton.setState({error: true})
        })
    },
    saveDraft: function() {
        // Clear out existing draft
        var deleteDraft = this.delete()
        var draftSaveButton = this
  
        draftSaveButton.setState({isSaving: true})
        deleteDraft.then(function() {
          var request = new XMLHttpRequest()
          // Hyrax has a hidden field on the edit form that switches it to PATCH, we don't want to PATCH -- that's weird
          $('[name="_method"]').val('post')
          var form = document.querySelector('.simple_form')
            var formData = new FormData(form)
          
            request.open('POST', '/draft/save_draft/'+draftSaveButton.props.curationConcernId)
            request.send(formData)

            request.onreadystatechange = function() {
                if (request.readyState === XMLHttpRequest.DONE) {
                    if (this.status === 200) {
                      draftSaveButton.setState({isSaved: true, isSaving: false})
                      $('[name="_method"]').val('patch')
                    } else {
                        draftSaveButton.setState({error: true, isSaving: false})
                    }
                }
            }
        })
    },
    delete: function() {
        // Delete the draft on the back-end
        return Promise.resolve($.post('/draft/delete_draft/' + this.props.curationConcernId))
    },
    revertDraft: function() {
        var deleteDraft = this.delete()
        var draftSaveButton = this;
        deleteDraft.then(function() {
            draftSaveButton.setState({isSaved: false})
            Turbolinks.visit(window.location.href)
        })
    }
})
