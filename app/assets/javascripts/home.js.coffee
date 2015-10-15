$(document).ready ($) ->
  #hide the subtle gradient layer (.cd-pricing-list > li::after) when pricing table has been scrolled to the end (mobile version only)

  checkScrolling = (tables) ->
    tables.each ->
      table = $(this)
      totalTableWidth = parseInt(table.children('.cd-pricing-features').width())
      tableViewport = parseInt(table.width())
      if table.scrollLeft() >= totalTableWidth - tableViewport - 1
        table.parent('li').addClass 'is-ended'
      else
        table.parent('li').removeClass 'is-ended'
      return
    return

  bouncy_filter = (container) ->
    container.each ->
      pricing_table = $(this)
      filter_list_container = pricing_table.children('.cd-pricing-switcher')
      filter_radios = filter_list_container.find('input[type="radio"]')
      pricing_table_wrapper = pricing_table.find('.cd-pricing-wrapper')
      #store pricing table items
      table_elements = {}
      filter_radios.each ->
        filter_type = $(this).val()
        table_elements[filter_type] = pricing_table_wrapper.find('li[data-type="' + filter_type + '"]')
        return
      #detect input change event
      filter_radios.on 'change', (event) ->
        event.preventDefault()
        #detect which radio input item was checked
        selected_filter = $(event.target).val()
        #give higher z-index to the pricing table items selected by the radio input
        show_selected_items table_elements[selected_filter]
        #rotate each cd-pricing-wrapper
        #at the end of the animation hide the not-selected pricing tables and rotate back the .cd-pricing-wrapper
        if !Modernizr.cssanimations
          hide_not_selected_items table_elements, selected_filter
          pricing_table_wrapper.removeClass 'is-switched'
        else
          pricing_table_wrapper.addClass('is-switched').eq(0).one 'webkitAnimationEnd oanimationend msAnimationEnd animationend', ->
            hide_not_selected_items table_elements, selected_filter
            pricing_table_wrapper.removeClass 'is-switched'
            #change rotation direction if .cd-pricing-list has the .cd-bounce-invert class
            if pricing_table.find('.cd-pricing-list').hasClass('cd-bounce-invert')
              pricing_table_wrapper.toggleClass 'reverse-animation'
            return
        return
      return
    return

  show_selected_items = (selected_elements) ->
    selected_elements.addClass 'is-selected'
    return

  hide_not_selected_items = (table_containers, filter) ->
    $.each table_containers, (key, value) ->
      if key != filter
        $(this).removeClass('is-visible is-selected').addClass 'is-hidden'
      else
        $(this).addClass('is-visible').removeClass 'is-hidden is-selected'
      return
    return

  checkScrolling $('.cd-pricing-body')
  $(window).on 'resize', ->
    window.requestAnimationFrame ->
      checkScrolling $('.cd-pricing-body')
      return
    return
  $('.cd-pricing-body').on 'scroll', ->
    selected = $(this)
    window.requestAnimationFrame ->
      checkScrolling selected
      return
    return
  #switch from monthly to annual pricing tables
  bouncy_filter $('.cd-pricing-container')

  $('#payment-form').submit (event)->
    $form = $(this)
    # Disable the submit button to prevent repeated clicks
    $form.find('button').prop('disabled', true)
    valid = true



    email = $.trim($('#signup-email').val());
    if email.length > 5 && validateEmail(email)
      $('#signup-email').removeClass('uk-form-danger')
    else
      $('#signup-email').addClass('uk-form-danger')
      valid = false

    $("form#payment-form :input").each ()->
      input = $(this)
      console.log 'Name: ' + input.attr('name')
      if input.val().length < 2
        input.addClass('uk-form-danger')
        valid = false
      else
        input.removeClass('uk-form-danger')


    first_name = $.trim($('#signup-first-name').val());
    last_name = $.trim($('#signup-last-name').val());
    address = $.trim($('#signup-address').val());
    city = $.trim($('#signup-city').val());
    state = $.trim($('#signup-state').val());
    zip = $.trim($('#signup-zip').val());
    ccnumber = $('#signup-cc').val()
    cvc = $('#signup-cc-cvc').val()
    exp_month = $('#signup-cc-exp-month').val()
    exp_year = $('#signup-cc-exp-year').val()


    if valid
      Stripe.card.createToken({
          number: ccnumber,
          cvc: cvc,
          exp_month: exp_month,
          exp_year: exp_year,
          name: (first_name + ' ' + last_name),
          address_line1: address,
          address_state: state,
          address_zip: zip,
          address_country: 'US'
      }, stripeResponseHandler)
    else
      alert 'All fields are required'
      $form.find('button').prop('disabled', false)

    # Prevent the form from submitting with the default action
    return false





  return



stripeResponseHandler = (status, response)->
  $form = $('#payment-form');

  if (response.error)
    # Show the errors on the form
    $form.find('.payment-errors').text(response.error.message);
    $form.find('button').prop('disabled', false);
  else
    # response contains id and card, which contains additional card details
    token = response.id;
    # Insert the token into the form so it gets submitted to the server
    $form.append($('<input type="hidden" name="stripeToken" />').val(token));
    # and submit
    # $form.get(0).submit();
    alert 'Got token: ' + response.id + ', submitting'

