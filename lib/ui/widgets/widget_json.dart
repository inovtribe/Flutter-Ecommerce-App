var homePage='''{
  "type": "Container",
  "padding":"10,10,10,10",
  "child": {
    "type": "ListView",
    "children": [
      {
        "type":"ClipRRect",
        "borderRadius":"10,10,10,10",
        "child":{
          "type":"AutofyCachedImage",
          "height":200.0,
          "src":"https://image.shutterstock.com/image-vector/sale-banner-template-design-big-260nw-1430068883.jpg",
          "fit":"fill"
        }
      },
      {
        "type":"HorizontalItemsSlider",
        "itemHeight":55.0,
        "children":[
          {
            "title":"Anti Theft",
            "imageSrc":"https://storage.googleapis.com/vksparrow/AutofyApp/banner1.jpg",
            "resourceId":10
          },
          {
            "title":"Bike Flashers",
            "imageSrc":"https://storage.googleapis.com/vksparrow/AutofyApp/banner2.jpg",
            "resourceId":10
          },
          {
            "title":"Helmets",
            "imageSrc":"https://storage.googleapis.com/vksparrow/AutofyApp/banner3.jpg",
            "resourceId":10
          },
          {
            "title":"Fog Lights",
            "imageSrc":"https://storage.googleapis.com/vksparrow/AutofyApp/banner1.jpg",
            "resourceId":10
          },
          {
            "title":"Locks",
            "imageSrc":"https://storage.googleapis.com/vksparrow/AutofyApp/banner2.jpg",
            "resourceId":10
          },
          {
            "title":"Anti Theft",
            "imageSrc":"https://storage.googleapis.com/vksparrow/AutofyApp/banner3.jpg",
            "resourceId":10
          }
        ]
      },
      {
        "type":"FocusedProductGrid",
        "count":6,
        "color":"0xffdf0145",
        "attributeType":"tag",
        "attributeId":2321,
        "title":"Best Sellers"
      }
    ]
}
}''';