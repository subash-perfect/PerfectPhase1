import PerfectHTTP
import PerfectHTTPServer
import PerfectLib
import PerfectMustache

let server = HTTPServer()
server.serverPort = 8080
server.documentRoot = "webroot"


struct Person: Codable {
    var name: String
    var age: Int
    var description: String
}

func returnJsonMessage(message: String, response: HTTPResponse) {
    do {
        try response
            .setBody(json: ["message": message])
            .setHeader(.contentType, value: "application/json")
            .completed()
    } catch {
        return response
            .setBody(string: "Error handling request")
            .completed(status: .internalServerError)
    }
}

var routes = Routes()

routes.add(method: .get, uri: "/helloMustache") { (request,response) in
    var values = MustacheEvaluationContext.MapType()
    values["name"] = "Subash"
    mustacheRequest(request: request, response: response, handler: MustacheHandler(values: values), templatePath: request.documentRoot + "/hello.mustache")
}

routes.add(method: .get, uri: "/helloMustache/{name}") { (request,response) in
    guard let name = request.urlVariables["name"] else {
        response.completed(status: .badRequest)
        return
    }
    var values = MustacheEvaluationContext.MapType()
    values["name"] = name
    mustacheRequest(request: request, response: response, handler: MustacheHandler(values: values), templatePath: request.documentRoot + "/hello.mustache")
}

routes.add(method: .get, uri: "/helloMustacheCollection") { (request,response) in
    var values = MustacheEvaluationContext.MapType()
    values["users"] = [
        ["name": "Subash", "email": "a@gmail.com"],
        ["name": "suji", "email": "b@gmail.com"]
    ]
    mustacheRequest(request: request, response: response, handler: MustacheHandler(values: values), templatePath: request.documentRoot + "/helloCollection.mustache")
}


routes.add(method: .get, uri: "/person") { (request, response) in
    let person = Person(name: "Subash", age: 29, description: "Cool guy!!!")
    try! response.setBody(json: person).completed()
}

routes.add(method: .get, uri: "beers/{num_beers}") { req, res in
    guard let numberOfBeerString = req.urlVariables["num_beers"],
        let numberOfBeer = Int(numberOfBeerString)  else {
            res.completed(status: .badRequest)
            return
    }
    returnJsonMessage(message: "Number of beer you specified \(numberOfBeer)", response: res)
}

routes.add(method: .post, uri: "post") { (req, res) in
    guard let name = req.param(name: "name") else {
        res.completed(status: .badRequest)
        return
    }
    returnJsonMessage(message: name, response: res)
}


server.addRoutes(routes)



do {
    try server.start()
} catch PerfectError.networkError(let err, let msg) {
    print("Network error thrown: \(err) \(msg)")
} catch {
    print(error.localizedDescription)
}




