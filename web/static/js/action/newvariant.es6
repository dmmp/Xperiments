import Store from 'store/index.es6';
import ActionHelper from 'modules/redux-actions/index.es6';
import {actions as ValidationErrorsActions} from 'action/validationerrors.es6';
import API from 'modules/api/index.es6';
import config from 'config.es6';

const validate = (data, variants = []) => {
  let errors = {};

  let totalAllocation = 0;
  try {
    totalAllocation = variants.reduce((a, b) => {
      return a.allocation + b.allocation;
    });
  } catch(e) {}
  let allocationLeft = 100 - totalAllocation;

  if (!data.name)
    errors.name = ['This field is required'];
  
  if (!data.allocation)
    errors.allocation = ['This field is required'];
  else if (isNaN(data.allocation))
    errors.allocation = ['Provide a valid number'];
  else if (data.allocation > allocationLeft)
    errors.allocation = [`Allocation can not be greater than 100% (${allocationLeft}% left)`];
  
  if (!data.payload) {
    errors.payload_type = ['This field is required'];
  } else {
    let payloadType = Object.keys(data.payload)[0];
    switch(payloadType) {
      case 'splashpagePlusCTA':
        if (!data.payload[payloadType].pathname)
          errors.payload_pathname = ['This field is required'];
        
        if (!data.payload[payloadType].pathname)
          errors.payload_search = ['This field is required'];
      case 'transferBubble':
        if (!data.payload[payloadType].delay)
          errors.payload_delay = ['This field is required'];
        else if (isNaN(data.payload[payloadType].delay))
          errors.payload_delay = ['Provide a valid number'];
        
        if (!data.payload[payloadType].timeout)
          errors.payload_timeout = ['This field is required'];
        else if (isNaN(data.payload[payloadType].timeout))
          errors.payload_timeout = ['Provide a valid number'];

        if (!data.payload[payloadType].textContent)
          errors.payload_textContent = ['This field is required'];
      case 'mobileHeader':
        if (!data.payload[payloadType].pathname)
          errors.payload_pathname = ['This field is required'];

        if (!data.payload[payloadType].text)
          errors.payload_text = ['This field is required'];
      case 'custom':
        if (!data.payload[payloadType].content) {
          errors.payload_content = ['This field is required'];
        } else {
          try {
            JSON.stringify(data.payload[payloadType].content);
          } catch(e) {
            errors.payload_content = ['Provide a valid JSON'];
          }
        }
    }
  }

  return errors;
}

export const actions = ActionHelper.types([
  'SET_NEW_VARIANT_VALUES',
  'RESET_NEW_VARIANT'
]);

export default ActionHelper.generate({
  setValues(data) {
    return dispatch => {
      dispatch({
        type: actions.SET_NEW_VARIANT_VALUES,
        data
      });
    };
  },

  reset() {
    return dispatch => {
      dispatch({
        type: actions.RESET_NEW_VARIANT
      });
    };
  },

  validate(data, formName) {
    return (dispatch, getState) => {
      const {experiment} = getState();
      const validationErrors = validate(data, experiment.variants);
      if (Object.keys(validationErrors).length) {
        dispatch({
          type: ValidationErrorsActions.SET_VALIDATION_ERRORS,
          form: formName,
          errors: validationErrors
        });
        throw 'ValidationErrors';
      }
    };
  }
});
