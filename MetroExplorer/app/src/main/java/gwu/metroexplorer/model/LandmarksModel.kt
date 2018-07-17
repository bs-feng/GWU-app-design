package gwu.metroexplorer.model

/**
 * Created by will on 10/16/17.
 */
data class LandmarksModel (
        val id: String, val title:String,
        val imageURL: String, val address: ArrayList<String>,
        val latitude:String, val longitude:String,
        val phone: String
)



