package gwu.metroexplorer.activity

import android.content.Context
import android.content.Intent
import android.support.v7.widget.RecyclerView
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.example.will.metro_m.Model.MetroModel
import gwu.metroexplorer.R
import kotlinx.android.synthetic.main.metrocell.view.*


class Metroadapter(var context:Context, val metro:ArrayList<MetroModel>): RecyclerView.Adapter<Metroadapter.ViewHolder>() {
    override fun onBindViewHolder(holder: ViewHolder?, position: Int) {
        holder?.bindItems(metro[position]) //To change body of created functions use File | Settings | File Templates.
    }


    override fun onCreateViewHolder(parent: ViewGroup?, viewType: Int): ViewHolder {
        val itemView = LayoutInflater.from(context).inflate(R.layout.metrocell,parent,false)
       return ViewHolder(itemView)
    }

    override fun getItemCount(): Int {
       return metro.size //To change body of created functions use File | Settings | File Templates.
    }

    inner class ViewHolder(itemView: View): RecyclerView.ViewHolder(itemView){
        fun bindItems(metro:MetroModel){
            itemView.metroname.text = metro.Name
            itemView.setOnClickListener{
                val intent = Intent(context,LandmarksActivity::class.java)

            }
        }
    }
}


