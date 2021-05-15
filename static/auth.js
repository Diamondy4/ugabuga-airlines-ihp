var triggerTabList = [].slice.call(document.querySelectorAll('#authTab a'))
console.log("im working")
triggerTabList.forEach(function (triggerEl) {
  var tabTrigger = new bootstrap.Tab(triggerEl)
  console.log(tabTrigger)
  triggerEl.addEventListener('click', function (event) {
    console.log(tabTrigger)
    event.preventDefault()
    tabTrigger.show()
  })
})
