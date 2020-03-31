const express = require('express')
const app = express()
const body_parser = require('body-parser')
const current_port = 3020 || process.ENV.port
const user_router = require('./routes/users')
const note_router = require('./routes/notes')
app.use(body_parser.json())
app.use('/users', user_router)
app.use('/notes', note_router)

app.listen(current_port, () => {
    console.log(`Listening on port ${current_port}.`)

})