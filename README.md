# Code Arena

## Overview
Code Arena is a web application designed to streamline the process of organizing, conducting, and evaluating coding contests. It aims to reduce the workload on teaching assistants (TAs) and improve the integrity of the contests by addressing issues such as plagiarism and manual evaluation.

## Table of Contents
- [Introduction](#introduction)
- [Features](#features)
- [Architecture](#architecture)
- [Frontend Implementation](#frontend-implementation)
- [Backend Implementation](#backend-implementation)
- [Limitations and Future Plans](#limitations-and-future-plans)
- [Conclusion](#conclusion)
- [Resources](#resources)
- [Installation](#installation)
- [Usage](#usage)
- [Deployment](#deployment)

## Introduction
During the first semester, significant challenges were encountered related to academic integrity and efficiency in evaluating students' work in the Introduction to Programming (ITP) course. The primary issues included plagiarism and the cumbersome manual evaluation of code submissions. Code Arena was developed to address these challenges by providing a comprehensive platform for coding contests.

## Features
- **Plagiarism Prevention:** Enforces a full-screen mode during contests to prevent switching tabs or windows, with warnings and potential disqualification for violations.
- **Automated Evaluation:** Allows TAs to create hidden test cases for questions, automatically evaluating student submissions and assigning marks based on test case results.
- **Administrative Efficiency:** Includes dedicated pages for creating, editing, and managing contests, questions, and student participation, streamlining administrative tasks.
- **Running the Code:**
  To run the code within the application

  - Navigate to the contest page and select the desired question.
  - Write your code in the provided editor.
  - Click the "Run Code" button to execute your code against sample test cases.
  - Review the output and make any necessary adjustments to your code.
- **Submitting the Code:**
  To submit your code for evaluation

  - Ensure your code runs successfully with the provided sample test cases.
  - Click the "Submit Code" button to submit your code.
  - Your submission will be evaluated against hidden test cases, and you will receive a score based on the results.

## Architecture
### Technology Stack
- **Frontend:** Flutter
- **Backend:** Node.js
- **Database:** Firebase Firestore
- **Storage:** Firebase Storage

### Frontend Architecture
Flutter is used to build a high-quality, cross-platform application. Key widgets and pages include:
- **LoginPage**
- **ForgotPasswordPage**
- **SignUpPage**
- **AdminPage**
  - Create/Edit Contest
  - Add/Delete Question
  - View Student Participation
- **StudentPage**
  - Register/Open Contest
  - Start Contest [Editor Page]
  - View Contest Participation

### Backend & Database Architecture
Node.js handles server setup and API requests, while Firebase Firestore and Storage manage dynamic data and user-generated content.

## Frontend Implementation
The Flutter framework is utilized for building the user interface, with widgets categorized into:
- **Stateless Widgets:** Static elements like buttons and text.
- **Stateful Widgets:** Dynamic elements like forms.
- **API Models:** Data models for backend communication.
- **API Endpoints:** URL definitions for server requests.
- **API Controllers:** Logic for performing CRUD operations.

## Backend Implementation
Node.js and Firebase are used to manage server-side operations, including:
- **Node.js:** Server setup, API requests, child process execution, and file operations.
- **Firebase Firestore:** Real-time NoSQL database for dynamic data management.
- **Firebase Storage:** Cloud storage solution for user-generated content.

## Limitations and Future Plans
While Code Arena addresses many challenges in organizing and evaluating coding contests, there are limitations and areas for future improvement, such as enhancing the user interface, adding more features for contest customization, and improving the scalability of the platform.

## Conclusion
Code Arena significantly reduces the administrative burden on TAs, enhances the integrity of coding contests, and provides an efficient and reliable method for evaluating student submissions.

## Resources
- Flutter
- Node.js
- Firebase Firestore
- Firebase Storage

## Installation
1. **Clone the repository:**
   ```sh
   git clone https://github.com/yourusername/code-arena.git

2. **Navigate to the project directory:**
   ```sh
   cd code-arena

3. **Install frontend dependencies:**
   ```sh
   flutter pub get

4. **Install backend dependencies:**
   ```sh
   cd backend
   npm install

## Usage
1. **Run the backend server:**
   ```sh
   cd backend
   npm start

2. **Run the frontend application:**
   ```sh
   flutter run

3. **Access the application:**
   Open your web browser and go to http://localhost:8080.

## Deployment
The project is deployed and can be accessed at https://mingo-omega.vercel.app/.
