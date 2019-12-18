import PerfectMustache

struct MustacheHandler: MustachePageHandler {
    var values: MustacheEvaluationContext.MapType
    func extendValuesForResponse(context contxt: MustacheWebEvaluationContext, collector: MustacheEvaluationOutputCollector) {
        contxt.extendValues(with: values)
        do {
            try contxt.requestCompleted(withCollector: collector)
        } catch {
            let response = contxt.webResponse
            response.appendBody(string: "\(error)")
            response.completed(status: .internalServerError)
        }
    }
}