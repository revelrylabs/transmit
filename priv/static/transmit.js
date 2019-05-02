function makeS3Request(data, file) {
  return new Promise((resolve, reject) => {
    const xhr = new XMLHttpRequest()

    xhr.onreadystatechange = () => {
      if (xhr.readyState === 4) {
        if (xhr.status === 200) {
          resolve(data.url)
        } else {
          reject({
            status: xhr.status,
            statusText: xhr.statusText,
          })
        }
      }
    }

    xhr.open('PUT', data.signed_request)
    xhr.send(file)
  })
}

/**
 *
 * @param {File} file - file to upload
 * @param {string} signerPath - The path to the signer endpoint. ex: /uploads/sign
 * @returns {string} The url to the file in S3
 * @example
 * import Transmit from 'transmit'
 *
 * const imageUploadElement = document.getElementById('avatar_uploader')
 * const urlElement = document.getElementById('avatar_url')
 * // Set up so that we upload to S3 when a file is given to the imageUploadElement
 * imageUploadElement.onchange = async () => {
 *   const file = imageUploadElement.files[0]
 *   if (file === null) {
 *     alert('No file selected.')
 *   } else {
 *      const url = await Transmit.uploadFileToS3(
 *       file,
 *       '/uploads/sign'
 *     )
 *     //saved to avatar_url element
 *     urlElement.value = url
 *   }
 * }
 *
 */
async function uploadFileToS3(file, signerPath) {
  const response = await fetch(
    `${signerPath}?file_name=${file.name}&file_type=${file.type}`
  )
  const {data} = await response.json()
  const url = await makeS3Request(data, file)

  return url
}

export default {
  uploadFileToS3,
}
