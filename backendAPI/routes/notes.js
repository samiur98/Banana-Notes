const express = require('express')
const router = express.Router()
const body_paser = require('body-parser')
router.use(body_paser.urlencoded({extended: true}))
router.use(body_paser.json())
const mysql = require('mysql')

const pool = mysql.createPool({
    connectionLimit: 150, //One less than that allowed by MySQL.
    host: 'localhost',
    user: 'root',
    password: 'boyzRback2514',
    database: 'banana_notes'
})

router.get('/getNotes/:userID', (req, res) => {
    //GET request for all notes of a user.
    console.log("Processing GET request for all notes of a user.")
    let user_id = req.params.userID

    sqlQuery = `SELECT * FROM notes WHERE user_id = ${user_id};`
    pool.query(sqlQuery, (err, rows, field) => {
        if(err){
            console.log(err)
            console.log("Error in connecting to database while processing GET request for all notes")
            res.sendStatus(500)
            return
        }
        res.send(rows)
    })
})

router.get('/getNote/:noteID', (req, res) => {
    //GET request for a particular note of a user.
    console.log("Processing GET request for a particular note of a user.")
    const noteID = req.params.noteID

    sqlQuery = `SELECT * FROM notes WHERE id = ${noteID};`
    pool.query(sqlQuery, (err, rows, fields) => {
        if(err){
            console.log(err)
            console.log("Error in connecting to notes database during GET request.")
            res.sendStatus(500)
            return
        }
        if(rows.length <= 0){
            console.log(`Note ${noteID} not found`)
            res.sendStatus(404)
            return
        }
        const noteID = rows[0].id
        const text = rows[0].note
        const title = rows[0].title
        res.send({"noteID" : noteID, "title" : title, "text" : text})
    })
})

router.post('/addNote/:userID', (req, res) => {
    //POST request for adding notes.
    console.log("Processing POST request for notes.")
    console.log(req.body);
    const userID = req.params.userID
    const title = req.body.title
    const text = req.body.note
    if((title.length > 100) || (text.length > 16000)){
        console.log("Title and/or note length exceeds allowed capacity.")
        res.sendStatus(400)
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
        console.log("POST request for adding note successfully processed")
        res.sendStatus(201)
    })
})

router.post('/updateNote/:noteID', (req, res) => {
    //POST request for updating notes.
    console.log("Processing POST request for notes.")
    console.log(req.body);
    const noteID = req.params.noteID
    const title = req.body.title
    const text = req.body.note
    if((title.length > 100) || (text.length > 16000)){
        console.log("Title and/or note length exceeds allowed capacity.")
        res.sendStatus(400)
        return
    }

    sqlQuery = `UPDATE notes SET note = '${text}', title = '${title}' WHERE id = ${noteID}`
    pool.query(sqlQuery, (err, rows, fields) => {
        if(err){
            console.log(err)
            console.log("Error in connecting to database during POST request.")
            res.sendStatus(500)
            return
        }
        console.log("POST request for updating note successfully processed")
        res.sendStatus(201)
    })
})

router.delete('/deleteNote/:noteID', (req, res) => {
    //DELETE request for notes.
    console.log("Processing DELETE request for notes.")
    const noteID = req.params.noteID

    sqlQuery = `DELETE FROM notes WHERE id = '${noteID}'`
    pool.query(sqlQuery, (err, rows, fields) => {
        if(err){
            console.log(err)
            console.log("Error in connecting to database during DELETE request")
            res.sendStatus(500)
            return
        }
        console.log("DELETE request for notes successfully processed.")
        res.sendStatus(204)
    })
})

module.exports = router