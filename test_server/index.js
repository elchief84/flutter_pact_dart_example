const express = require('express')
const bodyParser = require('body-parser');
const cors = require('cors');
const { v1: uuidv1, v4: uuidv4 } = require('uuid');

const app = express();
const port = 3000;

let books = [];
app.use(cors());

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

app.post('/book', (req, res) => {
    const book = {"id": uuidv4(), "title": req.body.title};

    if(req.body.description !== undefined) {
        book.description = req.body.description;
    }

    console.log(book);
    books.push(book);

    res.status(200).send(book);
});

app.get('/books', (req, res) => {
    if(books.length > 0) {
        res.send({"data": books, "count": books.length});
    }else{
        res.status(204).send();
    }
});

app.listen(port, () => console.log(`Books app listening on port ${port}!`));