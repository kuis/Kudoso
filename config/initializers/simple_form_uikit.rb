# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|
  config.error_notification_class = 'uk-alert uk-alert-danger'
  config.button_class = 'uk-button uk-button-primary'
  config.boolean_label_class = nil
  config.default_form_class = 'uk-form'

  config.wrappers :form_stacked, tag: 'div', class: 'uk-form-row', error_class: 'k-has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label, class: 'uk-form-label'
    b.use :input, class: 'uk-form-large uk-form-width-large'
    b.optional :maxlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :error, wrap_with: { tag: 'span', class: 'uk-form-danger' }
    b.use :hint,  wrap_with: { tag: 'span', class: 'uk-form-help-inline' }
  end

end
