package gwu.metroexplorer.activity

import android.content.Context
import com.google.gson.JsonArray
import com.koushikdutta.ion.Ion
import gwu.metroexplorer.model.LandmarksModel



class FetchLandmarksAsyncTask(){
    var landmarkCompletionListener: LandmarkCompletionCompletionListener? = null
    val radius = null
    val token:String? = "RWXbEQ26Yt0I1ckOf8vpzVyoRKjl7Y4oDrAuHU76SjvisFp0Wd9Dury9BPZqPW42"



    interface LandmarkCompletionCompletionListener{
        fun LandmarkCorrect(arr: ArrayList<LandmarksModel>)
        fun LandmarkNotFound()
        fun LandmarkDataNotLoaded()
    }

    fun data(context: Context){
        val r = Address()
        Ion.with(context).load(Constant.YELP_SEARCH_URL)
                .addHeader("Authorization",token)
                .addQuery("latitude",r.Lat)
                .addQuery("longitude",r.Lon)
                .addQuery("radius","10000")
                .asJsonObject()
                .setCallback { error, result ->
                    error?.let{
                        landmarkCompletionListener?.LandmarkDataNotLoaded()
                    }

                    result?.let{
                        //Using Yelp Bussiness API
                        val bussiness = result.get("bussiness")
                        if (bussiness != null){
                            if (bussiness.asJsonArray.size() > 0){
                                val bussinessArray = bussiness.asJsonArray
                                val landmarkArray = ArrayList<LandmarksModel>()
                                bussinessArray.forEach{
                                    val item = it.asJsonObject
                                    val locationArray = item.get("location").asJsonObject.get("display_address").asJsonArray
                                    val locationList = ArrayList<String>()
                                    locationArray.forEach {
                                        locationList.add(it.asString)
                                    }
                                    val landmark = LandmarksModel(item.get("id").asString,
                                            //Name
                                            item.get("name").asString,
                                            item.get("image_url").asString,
                                            locationList,
                                            item.get("coordinates").asJsonObject.get("latitude").asString,
                                            item.get("coordinates").asJsonObject.get("longtitude").asString,
                                            item.get("phone").asString)

                                    landmarkArray.add(landmark)
                                }
                                landmarkCompletionListener?.LandmarkCorrect(landmarkArray)
                            }else{
                                landmarkCompletionListener?.LandmarkNotFound()
                            }
                        }
                        else{
                            landmarkCompletionListener?.LandmarkDataNotLoaded()
                        }
                    }
                }
    }

}