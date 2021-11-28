//dependencies
const { application, response } = require('express');
const express = require('express');
const app = express();
const cors = require('cors');
app.use(cors({
    origin: 'http://10.0.2.2:1200/',
}));
app.use(express.json());
const nodemon = require('nodemon');

//MongoDB
const mongoose = require('mongoose');
const PORT = 1200;
const dbURL = "mongodb+srv://admin:Password1@cluster0.bmikw.mongodb.net/myFirstDatabase?retryWrites=true&w=majority";

mongoose.connect(dbURL,
    {
        useNewUrlParser: true,
        useUnifiedTopology: true
    }
);

//This is the MongoDB Connection
const db = mongoose.connection;
//Handle error/Display connection
db.on('error', () => {
    console.error.bind(console, 'connection error: ');
});
db.once('open', () => {
    console.log('MongoDB Connected');
});

//Set up Models
require('./Models/Course');
require('./Models/Student');
const Course = mongoose.model("COURSE");
const Student = mongoose.model("STUDENT");

//the below route can be used to make sure that postman is working. 
//To use: uncomment the section, and send a get request on localhost:1200/ and you will get the json body returned.
// app.get('/', (req, res) => {
//     return res.status(200).json("{message:'ok'}")
// });


//Below are the routes. Please pick one to work on and document.

//getAllCourses Route written by Tasha Denson-Byers
//DOCUMENTATION:
//After connecting to the server/API, to 'GET' all
//courses listed in the database, the await keyword works
//inside the async function to execute the action of finding
//all the records in courses using the empty 'find' function.
//The 'lean' function makes the process fast and easier on memory.
//Once the code executes, a response code of 200 is returned along
//with a listing of all of the 'courses' housed in the database.
//****************************
app.get('/getAllCourses', async (req, res) => {
    try {
        let courses = await Course.find({}).lean();
        return res.status(200).json({"courses":courses});
    }
    catch {
        return res.status(500);
    }
});

//ROUTENAME written by Abdishakur Abdi
//DOCUMENTATION:
/*
    this route gets all the stuednts information and then
    displays it as JSON format.
*/
//****************************
app.get('/getAllStudents', async (req, res) => {
    try {
        let students = await Student.find({})
        return res.status(200).json({"students":students});

    }
    catch {
        return res.status(500);
    }
});

//ROUTENAME written by Jax Pelzer
//DOCUMENTATION***************
//****************************
/*
    This is a get route that will find a student with first name 
    that is given and the display all other data on that student

*/
app.get('/findStudent', async (req, res) => {
    try {
        let student = await Student.find({ fname: req.body.fname });

        return res.status(200).json(student);
    }
    catch {
        return res.status(500);
    }
});

//findCourse written by Kevin
/*
    This route waits for user to insert a courseID in JSON format
     into the body like so:
     {
    "courseID":"MATH1500"
     }
*/
app.get('/findCourse', async (req, res) => {
    try {
        let course = await Course.find({ courseID: req.body.courseID })

        return res.status(200).json(course);
    }
    catch {
        return res.status(500);
    }
});

//addCourse written by Martin Schendel
//To add a course: 
//  send a POST request on localhost:1200/addCourse
//  body must be JSON that provides:
//  {"courseInstructor": "",
//  "courseCredits": #,
//  "courseID": "",
//  "courseName": "",
//  "dateEntered": "",}
app.post('/addCourse', async (req, res) => {
    try {
        let course = {
            courseInstructor: req.body.courseInstructor,
            courseCredits: req.body.courseCredits,
            courseID: req.body.courseID,
            courseName: req.body.courseName,
            dateEntered: req.body.dateEntered,
        }
        await Course(course).save().then(() => {
            return res.status(201).json("Course Added.");
        });
    }
    catch {
        return res.status(500);
    }
});

//ROUTENAME written by Coy Bailey
//This route allows the client to add a student to the database using the POST request
app.post('/addStudent', async (req, res) => {
    try {
        let student = {
            fname: req.body.fname,
            lname: req.body.lname,
            studentID: req.body.studentID,
            dateEntered: req.body.dateEntered
        }
        await Student(student).save().then(() => {
            return res.status(201).json("Student Added.");
        });
    }
    catch {
        return res.status(500);
    }
});

/*
    BEGINNING OF ASSIGNMENT 7
    /editStudentById
    This route will allow someone to update the first name record based on a query by studentID.
    {
    "studentID":"S006",
    "fname":"TestGood"
    }
*/

app.post('/editStudentById', async (req, res) => {
    try {
        let student = await Student.updateOne({studentID: req.body.studentID},{
            fname: req.body.fname
        },{upsert:true});
        if(student){
            return res.status(200).json("{message: Student Updated!}");
        }else{
            return res.status(200).json("{message: No student Found}");
        }
    }
    catch {
        return res.status(500).json("{message:Failed to edit student}");
    }
});



/*
    /editStudentByFname
    This route will allow someone to update the first name and last name based on a query by fname.
    {
    "queryFname":"TestGood",
    "fname":"Test",
    "lname":"Good"
    }
*/

app.post('/editStudentByFname', async (req, res) => {
    try {
        let student = await Student.updateOne({fname: req.body.queryFname},{
            fname: req.body.fname,
            lname: req.body.lname
        },{upsert:true});
        if(student){
            return res.status(200).json("{message: Student Updated!}");
        }else{
            return res.status(200).json("{message: No student Found}");
        }
    }
    catch {
        return res.status(500).json("{message:Failed to edit student}");
    }
});

/*
    /editCourseByCourseName
    This route will allow someone to update The instructor of a course by searching for the courseNamne.
    {
    "courseName":"Test",
    "instructorsName":"NewTest"
    }
*/

app.post('/editCourseByCourseName', async (req, res) => {
    try {
        let course = await Course.updateOne({courseName: req.body.courseName},{
            courseInstructor: req.body.instructorsName
        },{upsert:true});
        if(course){
            return res.status(200).json("{message: course Updated!}");
        }else{
            return res.status(200).json("{message: No course Found}");
        }
    }
    catch {
        return res.status(500).json("{message:Failed to edit course}");
    }
});

/*
    /editCourseByCourseName
    This route will allow someone to delete a course by searching for the CourseID.
  {
    "courseID":"0000"
  }
*/
app.post('/deleteCourseById', async (req, res) => {
    try {
        let course = await Course.findOne({courseID: req.body.courseID});
        if(course){
            await Course.deleteOne({courseID: req.body.courseID});
            return res.status(200).json("{message: course deleted}");
        }else{
            return res.status(200).json("{message: No course Found}");
        }
    } catch{
        return res.status(500).json("{message:Failed to delete course}");
    }
});

/*
    /removeStudentFromClasses
    This route will allow someone to delete a student by searching for their studentID.
    {
    "studentID":"S006"
    }
*/
app.post('/removeStudentFromClasses', async (req, res) => {
    try {
        let student = await Student.findOne({studentID: req.body.studentID});
        if(student){
            await Student.deleteOne({studentID: req.body.studentID});
            return res.status(200).json("{message: student deleted}");
        }else{
            return res.status(200).json("{message: No student Found}");
        }
    } catch{
        return res.status(500).json("{message:Failed to delete student}");
    }
});
app.post('/delete', async (req, res) => {
    try {
        let student = await Student.findOne({_id: req.body._id});
        if(student){
            await Student.deleteOne({_id: req.body._id});
            return res.status(200).json("{message: student deleted}");
        }else{
            return res.status(200).json("{message: No student Found}");
        }
    } catch{
        return res.status(500).json("{message:Failed to delete student}");
    }
});

//Start the Server
app.listen(PORT, () => {
    console.log(`API for Assignment 7 now running on port: ${PORT}`)
});
