package gwu.metroexplorer.activity

import android.content.Context
import com.beust.klaxon.Parser
import com.example.will.metro_m.Model.MetroModel
import com.google.gson.JsonArray
import com.koushikdutta.ion.Ion


class FetchMetroStationMananger(val context: Context)

{


    val token:String? = "c7a74d4c47294ea4904c09c229cb028d"

    val address:String? = null
    private val TAG = "FetchMetroStationMananger"

    var locationListCompletionListener: LocationListCompletionListener? = null

    interface LocationListCompletionListener{
        fun locationListloaded( arr: ArrayList<MetroModel>)
        fun locationListNotloaded()
        fun locationListNotFound()
    }

    var locationSearchCompletionListener: LocationSearchCompletionListener? = null

    interface LocationSearchCompletionListener{
        fun locationloaded(arr: String)
        fun locationNotloaded()
        fun locationNotFound()
    }


    var nearSearchListener:nearSearchCompletionListener? = null
    interface nearSearchCompletionListener{
        fun locationloaded(arr: JsonArray)
        fun locationNotloaded()
        fun locationNotFound()
    }
    fun locationFound(){

    }

    fun locationNotloaded(){

    }

    fun parse(name: String) : Any? {
        val cls = Parser::class.java
        return cls.getResourceAsStream(name)?.let { inputStream ->
            return Parser().parse(inputStream)
        }
    }

    val parser: Parser = Parser()
    // var json: JsonObject = parser.parse(url) as JsonObject

    fun metro_list(){
        val r = Address()
        Ion.with(context).load(Constant.METRO_LIST_URL)
                .addHeader("api_key", token)
                .asJsonObject()
                .setCallback { error, results ->
                    error?.let{
                        locationListCompletionListener?.locationListNotloaded()
                    }
                    results?.let {
                        val result = results.get("Stations")
                        if(result != null){
                            if(result.asJsonArray.size()>0){
                                val infoArray = result.asJsonArray
                                val addressArray = ArrayList<MetroModel>()
                                infoArray.forEach{
                                    val item =it.asJsonObject
                                    val address = MetroModel(item.get("Name").asString,

                                            item.get("Code").asString,
                                            item.get("Lat").asString,
                                            item.get("Lon").asString)
                                    addressArray.add(address)
                                }
                                locationListCompletionListener?.locationListloaded(addressArray)
                            }else{
                                locationListCompletionListener?.locationListNotFound()
                            }
                        }else{
                            locationListCompletionListener?.locationListNotloaded()
                        }
                    }
                }
    }

    fun near(lat: String, lon: String){
        Ion.with(context).load(Constant.METRO_ENTRANCE)
                .addHeader("api_key",token)
                .addQuery("Lat",lat)
                .addQuery("Lon",lon)
                .addQuery("Radius","1000")
                .asJsonObject()
                .setCallback { error, results ->
                    error?.let {
                        nearSearchListener?.locationNotFound()
                    }
                    results?.let {
                        val result = results.get("Entrances")
                        if (result != null) {
                            if (result.asJsonArray.size() > 0) {
                                val infoArray = result.asJsonArray
                                val code = infoArray[0].asJsonObject.get("StationCode1").asString

                                Ion.with(context).load(Constant.METRO_SEARCH_URL)
                                        .addHeader("api_key",token)
                                        .addQuery("StationCode",code)
                                        .asJsonObject()
                                        .setCallback { error, results ->
                                            error?.let{
                                                locationSearchCompletionListener?.locationNotFound()
                                            }
                                            result?.let {
                                                val address = results.get("Name").asString
                                                if (address != null) {
                                                    if (address.length > 0) {


                                                        locationSearchCompletionListener?.locationloaded(address)
                                                    } else {
                                                        locationSearchCompletionListener?.locationNotFound()

                                                    }
                                                } else {
                                                    locationSearchCompletionListener?.locationNotloaded()
                                                }
                                            }
                                        }





//                                nearSearchListener?.locationloaded(infoArray)


                            } else {
                                nearSearchListener?.locationNotFound()
                            }
                        } else {
                            nearSearchListener?.locationNotloaded()
                        }

                    }




                }
    }
}