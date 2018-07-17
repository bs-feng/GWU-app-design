package gwu.metroexplorer.adapter

import android.content.Intent
import android.support.v7.widget.RecyclerView
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import com.example.will.metro_m.Model.MetroModel
import gwu.metroexplorer.Interface.CustomItemClickListener
import gwu.metroexplorer.R
import gwu.metroexplorer.activity.LandmarksActivity



class MetroStationsAdapter (var nameList: ArrayList<MetroModel>) : RecyclerView.Adapter<MetroStationsAdapter.ViewHolder>(){


    override fun onBindViewHolder(holder: ViewHolder?, position: Int) {
        //recyclerview
        holder?.bind(nameList[position].Name)

        //pass data to new activity
        holder?.setOnCustomItemClickListener(object: CustomItemClickListener{
            override fun onCustomItemClickListener(view: View, position: Int) {
                var i = Intent(view.context, LandmarksActivity::class.java)
                i.putExtra("name", nameList[position].Name)
                view.context.startActivity(i)
            }
        })

    }

    override fun onCreateViewHolder(parent: ViewGroup?, viewType: Int): ViewHolder{
        val layoutInflater = LayoutInflater.from(parent?.context)
        return ViewHolder(layoutInflater.inflate(R.layout.row_metrostation, parent, false))
    }

    override fun getItemCount(): Int {
        return nameList.count()
    }

    inner class ViewHolder(itemView: View): RecyclerView.ViewHolder(itemView), View.OnClickListener{

        //recyclerview item onClick listener
        var customItemClickListener: CustomItemClickListener? = null
        init {
            itemView.setOnClickListener(this)
        }

        fun setOnCustomItemClickListener(itemClickListener: CustomItemClickListener){
            this.customItemClickListener = itemClickListener
        }

        override fun onClick(p0: View?) {
            this.customItemClickListener!!.onCustomItemClickListener(p0!!, adapterPosition)
        }

        //recyclerview bind
        fun bind(name: String){
            val nameTextView: TextView = itemView.findViewById(R.id.metrostation_name)
            nameTextView.text = name
        }
    }

    //recyclerview filter function, updates the data

    fun setFilter (newList:ArrayList<MetroModel>){

        nameList = newList
        notifyDataSetChanged()
    }


}
/*
Learn how to do: pass data to new activity, recyclerview onClick, filter recyclerview by these websites:
http://camposha.info/source/android-master-detail-recyclerview-images-text/
https://stackoverflow.com/questions/41514249/how-to-open-new-activity-on-item-click-with-different-data-and-photo-in-recycler
https://www.youtube.com/watch?v=Xz91blKKCpA
https://www.youtube.com/watch?v=j9_hcfWVkIc&t=1338s
 */