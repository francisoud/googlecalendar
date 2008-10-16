<script language="javascript">
    function displayHideSection(labelSection) {
      if ((document.getElementById(labelSection).style.display == "") || (document.getElementById(labelSection).style.display == "none")) {	
		document.getElementById(labelSection).style.display = "block";
      }	else if (document.getElementById(labelSection).style.display == "block") {		
		document.getElementById(labelSection).style.display = "none";
      }
    }
</script>