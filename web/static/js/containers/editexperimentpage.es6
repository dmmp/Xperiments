import Store from 'store/index.es6';
import {connect} from 'react-redux';
import Actions from 'action/index.es6';
import EditExperimentPage from 'component/page/editexperiment.es6';

const setValue = (key, value) => {
  let data = {};
  data[key] = value;
  return Actions.Experiment.setValues(data);
}

const mapStateToProps = (state) => {
  return {
    experiment: state.experiment
  }
}

const mapDispatchToProps = (dispatch, ownProps) => {
  return {
    save: (data) => {
      dispatch(Actions.Experiment.update(data));
    }
  }
}

const EditExperiment = connect(
  mapStateToProps,
  mapDispatchToProps
)(EditExperimentPage);

export default EditExperiment;