const express = require('express')
const router = express.Router()
const body_paser = require('body-parser')
router.use(body_paser.urlencoded({extended: false}))
const mysql = require('mysql')

const pool = mysql.createPool({
    connectionLimit: 150, //One less than that allowed by MySQL.
    host: 'localhost',
    user: 'root',
    password: 'boyzRback2514',
    database: 'banana_notes'
})

router.get('/getNote/:userID/:title', (req, res) => {
    //GET request for notes.
    console.log("Processing GET request for notes.")
    const title = req.params.title
    const userID = req.params.userID

    sqlQuery = `SELECT * FROM notes WHERE 'user_id' = ${userID} AND 'title' = '${title}';`
    pool.query(sqlQuery, (err, rows, fields) => {
        if(err){
            console.log("Error in connecting to notes database during GET request.")
            res.sendStatus(500)
            return
        }
        if(rows.length <= 0){
            console.log(`Note ${title} not found for user ${userID}`)
            res.sendStatus(404)
            return
        }
        const noteID = rows[0].id
        const text = rows[0].note
        res.send({"userID" : userID, "noteID" : noteID, "title" : title, "text" : text})
    })
})

router.post('/addNote/:userID/:title/:text', (req, res) => {
    //POST request for notes.
    console.log("Processing POST request for notes.")
    const userID = req.params.userID
    console.log(userID)
    const title = req.params.title
    const text = req.params.text
    if((title.length > 100) || (text.length > 16000)){
        console.log("Title and/or note length exceeds allowed capacity.")
        res.send(400)
        return
    }

    sqlQuery = `INSERT INTO notes (user_id, title, note) values (${userID}, "${title}", "${text}");`
    pool.query(sqlQuery, (err, rows, fields) => {
        if(err){
            console.log(err)
            console.log("Error in connecting to database during POST request.")
            res.sendStatus(500)
            return
        }
        console.log("POST request for notes successfully processed")
        res.sendStatus(201)
    })
})

module.exports = router