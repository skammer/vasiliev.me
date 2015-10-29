var sausage = document.querySelector('.scrollable-sausage');
var menu    = document.querySelector('.background-info');

sausage.onclick = function() {
  sausage.classList.toggle('transformed');
  menu.classList.toggle('transformed');

  // DIrty Safari repaint hack
  document.body.style.zoom = 1.0000001;
  setTimeout(function() {
    document.body.style.zoom = 1;
  }, 2000)
}

// sausage.click();
