APP.components.createzuckerl = (function() {

    var price_graetzl = $('[data-behavior=zuckerlform] #zuckerl_graetzl_price').val();
    var price_all_districts = $('[data-behavior=zuckerlform] #zuckerl_all_districts_price').val();

    var $titleinput, $descriptioninput, $imageinput, $districtinput, $titlepreview,
        $descriptionpreview, $imagepreview, $pricepreview, $btnconfirm, $btnsend,
        $graetzlpreview, $alldistrictspreview;

    function init() {

        $titleinput = $("[data-behavior=titleinput]");
        $descriptioninput = $("[data-behavior=descriptioninput]");
        $linkinput = $("[data-behavior=linkinput]");
        $imageinput = $("[data-behavior=imageinput]");
        $districtinput = $('.district_visibility .input-radio');
        $titlepreview = $("[data-behavior=titlepreview]");
        $linkpreview = $("a.linkpreview");
        $descriptionpreview = $("[data-behavior=descriptionpreview]");
        $pricepreview = $("[data-behavior=pricepreview]");
        $graetzlpreview = $("[data-behavior=graetzlpreview]");
        $alldistrictspreview = $("[data-behavior=alldistrictspreview]");
        $imagepreview = $("[data-behavior=imagepreview]");
        $btnconfirm = $("[data-behavior=btn-confirm]");
        $btnsend = $("[data-behavior=btn-send]");

        $descriptioninput.autogrow({ onInitialize: true });

        bindevents();
        updatetitle();
        updatedescription();
        updatelink();
        updatedistricts();
        btnclickability();
        disabledistricts();
        $linkpreview.hide();
    }

    function bindevents() {
        $titleinput.on("keyup change", updatetitle);
        $descriptioninput.on("keyup change", updatedescription);
        $linkinput.on("keyup change", updatelink);
        $imageinput.on("upload:complete", updateimage);
        $districtinput.on("change", updatedistricts);
        $btnconfirm.on("click", btnstate);
        $("[data-behavior=zuckerlform]").on("submit", submitzuckerlform);
        $titleinput.add($descriptioninput).add($imageinput).on("keyup change", function() {
            btnclickability();
            btnstate("reset");
        });
    }

    function disabledistricts() {
        $('.-edit .district_visibility input:radio').attr('disabled',true);
    }

    function updatetitle() {
        if ($titleinput.val()) $titlepreview.removeClass("placeholder").text($titleinput.val());
        else $titlepreview.addClass("placeholder").text("Titel des Angebots");
    }

    function updatedescription() {
        if ($descriptioninput.val()) $descriptionpreview.removeClass("placeholder").text($descriptioninput.val());
        else $descriptionpreview.addClass("placeholder").text("Beschreibung des Angebots");
    }

    function updatelink() {
        if ($linkinput.val()) {
          $linkpreview.attr("data-behavior", $linkinput.val());
          $linkpreview.show();
        }
        else {
          $linkpreview.hide();
        }
    }

    function updatedistricts() {
      var selected_area = $(".district_visibility input[type='radio']:checked").data('behavior');
      if (selected_area == "all_districts_true") {
        $('.description .graetzl').hide();
        $('.description .all_districts').show();
        $pricepreview.text(price_all_districts);
        $graetzlpreview.hide();
        $alldistrictspreview.show();
      } else {
        $('.description .all_districts').hide();
        $('.description .graetzl').show();
        $pricepreview.text(price_graetzl);
        $alldistrictspreview.hide();
        $graetzlpreview.show();
      }
    }

    function updateimage() {
        FileAPI.Image(this.files[0]).preview(300, 185).get(function (err, img){
            $imagepreview.empty().append(img);
        });
    }

    function validatefields() {
        return ($titleinput.val().length > 0 && $descriptioninput.val().length > 0 && $imageinput.val().length > 0);
    }

    function btnclickability() {
        if(validatefields()) $btnconfirm.removeClass('-disabled');
        else $btnconfirm.addClass('-disabled', true);
    }

    function submitzuckerlform(e) {
        if($btnsend.exists() && !$btnsend.hasClass("is-visible")) {
            e.preventDefault();
        }
    }

    function btnstate(mode) {
        if(mode === "reset") {
            $btnconfirm.show();
            $btnsend.removeClass("is-visible");
        } else {
            $btnconfirm.hide();
            $btnsend.addClass("is-visible");
        }
    }

    $("a.linkpreview").on('click', function(){
      var link = $("a.linkpreview").attr("data-behavior");
      if (!link.match(/^[a-zA-Z]+:\/\//)) {
          link = 'http://' + link;
      }
      window.open(link, '_blank');
    });


    return {
        init: init
    }


})();
