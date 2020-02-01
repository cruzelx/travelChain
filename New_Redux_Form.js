import React from 'react'
import { Field, reduxForm } from 'redux-form';
import axios from 'axios';


const FileInput = ({
  input: { value: omitValue, onChange, onBlur, ...inputProps },
  meta: omitMeta,
  ...props
}) => {
  return (
    <input
      onChange={adaptFileEventToValue(onChange)}
      onBlur={adaptFileEventToValue(onBlur)}
      type="file"
      {...props.input}
      {...props}
    />
  );
};

export const FileUpload = (props) => {
    const { handleSubmit } = props;
    // console.log(props)
    const onFormSubmit = (values,error,data) => {
        let formData = new FormData();
        formData.append('name', data.name)
        console.log(values)
        formData.append('profile_pic', data.profile_pic[0])
        const config = {
            headers: { 'content-type': 'multipart/form-data' }
        }
        const url = 'https://projectdocumentation.herokuapp.com/addscreenshot/';
        axios.post(url, data, config)
            .then(function(response) {
                console.log(response);
            })
            .catch(function(error) {
                console.log(error);
            });
        console.log(data);
    }
    return (
          <form onSubmit={handleSubmit(onFormSubmit)}>
            <div>
              <label>Attachment</label>
              <Field name="attachment" component='input' type="file"/>
            </div>
            <button type="submit">Submit</button>
          </form>
    )
}

export default reduxForm({
    form: 'fileupload'
})(FileUpload)
