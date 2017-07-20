import SelectWorkType from 'hyrax/select_work_type'
export default class TuftsSelectWorkType extends SelectWorkType {
  destination () {
    return this.form.find('.work-type-title:selected').data(this.type)
  }
}