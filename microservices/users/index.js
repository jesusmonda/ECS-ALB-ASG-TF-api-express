const express = require('express')
const app = express()
const port = 3000
const axios = require('axios');

app.get('/health', (req, res) => {
  res.send('OK')
})

app.get('/', async (req, res) => {
  try {
    const response = await axios.get('http://api-posts.jesusmonda.dev:3000/health')
    console.log(response, response.data)
    res.send(response.data)
  } catch (error) {
    res.send("Error" + error)
  }
})

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})