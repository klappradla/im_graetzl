APP.components.imgUploadPreview = function() {


    $('.js-imgUpld').each(function() {

        var $this = $(this);

        $this.find('input[type=file]').on('change', function() {
            if (this.files && this.files[0]) {
                var reader = new FileReader();
                reader.onload = function (event) {
                    injectImage($this);
                    showDeleteIcon($this);
                };
                reader.readAsDataURL(this.files[0]);
            }
        });

        $this.find('.icon-delete]').on('click', function() {
            resetLocalImg($this);
        });

        $this.find('.deleteCheckbox').on('change', function() {
            (this.checked) ? $this.find('.imgCrop').hide() : $this.find('.imgCrop').show();
        })

    });

    function injectImage($element) {
        $element
            .find('.imgCrop').remove().end()
            .prepend('<div class="imgCrop"><img src=' + event.target.result +'></div>');
        adjustImg($element.find('img'));
    }


    function showDeleteIcon($element) {
        $element
            .find('.icon-delete').show().end()
            .find('.deleteCheckbox').removeAttr('checked').end()
            .find('.checkbox-group').hide()
    }

    function resetLocalImg($element) {
        $element
            .find('.imgCrop').remove().end()
            .find('.icon-delete').hide().end()
            .find('.deleteCheckbox').attr('checked', 'checked').end()
            .find('input[type=file]').val('');
    }

    function adjustImg($img) {
        // what's the size of this image and it's parent
        var w = $img.width();
        var h = $img.height();
        var tw = $img.parent().width();
        var th = $img.parent().height();

        // compute the new size and offsets
        var result = scaleImg(w, h, tw, th, false);

        // adjust the image coordinates and size
        $img.attr("width", result.width);
        $img.attr("height", result.height);
        $img.css("left", result.targetleft);
        $img.css("top", result.targettop);
    }

    function scaleImg(srcwidth, srcheight, targetwidth, targetheight, fLetterBox) {

        var result = { width: 0, height: 0, fScaleToTargetWidth: true };

        if ((srcwidth <= 0) || (srcheight <= 0) || (targetwidth <= 0) || (targetheight <= 0)) {
            return result;
        }

        // scale to the target width
        var scaleX1 = targetwidth;
        var scaleY1 = (srcheight * targetwidth) / srcwidth;

        // scale to the target height
        var scaleX2 = (srcwidth * targetheight) / srcheight;
        var scaleY2 = targetheight;

        // now figure out which one we should use
        var fScaleOnWidth = (scaleX2 > targetwidth);
        if (fScaleOnWidth) {
            fScaleOnWidth = fLetterBox;
        }
        else {
            fScaleOnWidth = !fLetterBox;
        }

        if (fScaleOnWidth) {
            result.width = Math.floor(scaleX1);
            result.height = Math.floor(scaleY1);
            result.fScaleToTargetWidth = true;
        }
        else {
            result.width = Math.floor(scaleX2);
            result.height = Math.floor(scaleY2);
            result.fScaleToTargetWidth = false;
        }
        result.targetleft = Math.floor((targetwidth - result.width) / 2);
        result.targettop = Math.floor((targetheight - result.height) / 2);

        return result;
    }


};
