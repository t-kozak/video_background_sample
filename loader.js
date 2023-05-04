const _srcAttrib = "data-src"
const _srcAttribPortrait = "data-portrait-src"


function loadVids() {
    console.log('Fetching them videos')
    let videos = allByTag('video')
    for (let i = 0; i < videos.length; i++) {
        _loadVid(videos[i])
    }
}

function isPortrait() {
    let h = window.screen.availHeight
    let w = window.screen.availWidth
    return w / h < 1.0;
}

function _loadVid(video) {

    video.childNodes.forEach((srcNode) => {
        if (srcNode.hasAttribute && srcNode.hasAttribute(_srcAttrib)) {
            srcNode.src = _getVidSrc(srcNode)
        }
    })

    function onErr(e) {
        console.log('Got vid error for')
        console.log(e.target.error.message)
    }

    function onLoaded(e) {
        video.play()
    }

    video.onerror = onErr
    video.onloadeddata = onLoaded
    video.load()
}


function _getVidSrc(sourceNode) {
    if (isPortrait()) {
        return sourceNode.getAttribute(_srcAttribPortrait)
    }
    return sourceNode.getAttribute(_srcAttrib)
}

function allByTag(tag) {
    let tagClean = tag.toUpperCase()
    let eles = document.getElementsByTagName(tagClean);
    return eles;
}


window.setTimeout(loadVids, 500)