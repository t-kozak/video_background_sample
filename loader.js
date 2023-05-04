const _srcAttrib = "data-src"
const _srcAttribPortrait = "data-portrait-src"

// must match what is used in style.css as media query
const _landscapeMinAR = 1.0

// Main function that loads all videos. Useful with any video tag, not only the background. Can be simplified
// if you're dealing just with the background video.
function loadVids() {
    console.log('Fetching them videos')
    let videos = document.getElementsByTagName('VIDEO')
    for (let i = 0; i < videos.length; i++) {
        _loadVid(videos[i])
    }
}


function _loadVid(video) {

    video.childNodes.forEach((srcNode) => {
        // go through all the sources and pick appropriate src file - either portrait or landscape
        if (srcNode.hasAttribute && srcNode.hasAttribute(_srcAttrib)) {
            srcNode.src = _getVidSrc(srcNode)
        }
    })

    function onErr(e) {
        console.log('Got vid error for')
        console.log(e.target.error.message)
    }

    // Autoplay. Please note that if you're using this script on a page with more video tags, you may want
    // to filter which videos are to be auto-played.
    function onLoaded(e) {
        video.play()
    }

    video.onerror = onErr
    video.onloadeddata = onLoaded

    video.load()
}


function _getVidSrc(sourceNode) {
    if (_isLandscape()) {
        return sourceNode.getAttribute(_srcAttrib)
    }
    return sourceNode.getAttribute(_srcAttribPortrait)
}

function _isLandscape() {
    let h = window.screen.availHeight
    let w = window.screen.availWidth
    return w / h > _landscapeMinAR;
}


// Give a page some time to init before loading really heavy videos.
window.setTimeout(loadVids, 500)