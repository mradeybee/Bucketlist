# Bucketlist

[![Code Climate](https://codeclimate.com/github/andela-aadepoju/Bucketlist/badges/gpa.svg)](https://codeclimate.com/github/andela-aadepoju/Bucketlist) [![Issue Count](https://codeclimate.com/github/andela-aadepoju/Bucketlist/badges/issue_count.svg)](https://codeclimate.com/github/andela-aadepoju/Bucketlist) [![Coverage Status](https://coveralls.io/repos/andela-aadepoju/Bucketlist/badge.svg?branch=master&service=github)](https://coveralls.io/github/andela-aadepoju/Bucketlist?branch=master)

## Description
This is an API for a bucket list service. Specification for the API is shown below.

## End Points Functionalities
|End Point| Function  |
|---------------------|:----:|
|**POST /auth/login:** |Logs a user in
| **GET /auth/logout:**| Logs a user out
| **POST /bucketlists:**| Creates a new bucket list
| **GET /bucketlists:**| Lists all the created bucket lists
|**GET /bucketlists/(id):**| Gets a single bucket list
| **PUT /bucketlists/(id):** |Updates this single bucket list
| **DELETE /bucketlists/(id):**| Deletes this single bucket list
| **POST /bucketlists/(id)/items:** |Creates a new item in bucket list
|**PUT /bucketlists/(id)/items/(item_id):**| Updates a bucket list item
|**DELETE /bucketlists/(id)/items/(item_id):**| Deletes an item in a bucket list

## Data Model
 The JSON data model for a bucket list and a bucket list item is shown below.

```
{
	id: 1,
	name: “BucketList1”,
	items: [
  		   {
               id: 1,
               name: “I need to do X”,
               date_created: “2015-08-12 11:57:23”,
               date_modified: “2015-08-12 11:57:23”,
               done: False
             }
           ]
	date_created: “2015-08-12 11:57:23”,
	date_modified: “2015-08-12 11:57:23”
	created_by: “Owner's Name”
}
```

## Authentication
Json Web Tokens(JWT), Token Based System was used for this API. With this, some end points are not accessible to unauthenticated users. Access control mapping is listed below.

### End Point and Public Access
|End Point| Publicity  |
|---------------------|:----:|
|**POST /auth/login:**| TRUE |
| **GET /auth/logout:**| FALSE|
| **POST /bucketlists:**| FALSE|
| **GET /bucketlists:**| FALSE|
| **GET /bucketlists/(id):**| FALSE|
| **PUT /bucketlists/(id):**| FALSE|
| **DELETE /bucketlists/(id):**| FALSE |
|**POST /bucketlists/(id)/items:**|  FALSE|
| **PUT /bucketlists/(id)/items/(item_id):**| FALSE|
| **DELETE /bucketlists/(id)/items/(item_id):**| FALSE|

## Pagination
This API is paginated such that users can specify the number of results they would like to have via a `GET parameter` `limit`.

#### Example

**Request:**
```
GET https://beebuckets.herokuapp.com/v1/bucketlists?page=2&limit=20
```

**Response:**
```
20 bucket list records belonging to the logged in user starting from the 21st bucket list .
```

  ## Searching by Name
  Users can search for bucket list by its name using a `GET parameter` `q`.
  #### Example

  **Request:**
  ```
  GET https://beebuckets.herokuapp.com/v1/bucketlists?q=bucket1
  ```

  **Response:**
  ```
  Bucket lists with the string “bucket1” in their name.
  ```

## Versions
This API has only one version for now, and it can be accessed via -
```
https://beebuckets.herokuapp.com/v1/endpoint
```

## Use Online
 This API is currently hosted on:
 [https://beebuckets.herokuapp.com/](https://beebuckets.herokuapp.com/)

## Contributions
 This API is open source and contributions are welcomed. You can clone the [Github](https://github.com/andela-aadepoju/Bucketlist) repository and raise a `pull request` for your contributions.  

 Thank You

 [Adepoju Adebayo](www.mradeybee.com), Software developer at [Andela](www.andela.com)
