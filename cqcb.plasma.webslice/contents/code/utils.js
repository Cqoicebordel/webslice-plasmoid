/**
 * Transform a model into a string representing the model as an array
 */
function stringifyModel(model) {
    var newArray = []
    for (var i = 0; i < model.count; i++) {
        var obj = model.get(i)
        newArray.push(obj.url)
    }
    return JSON.stringify(newArray)
}

/**
 * Get an array from a string representing that array
 */
function getURLsObjectArray() {
    var cfgURLS = plasmoid.configuration.urlsModel
    if (!cfgURLS) {
        return []
    }
    return JSON.parse(cfgURLS)
}
