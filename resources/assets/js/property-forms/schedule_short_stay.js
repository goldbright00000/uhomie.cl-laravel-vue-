const _token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
const _property = document.getElementById('property_id').value;

import VCalendar from 'v-calendar/lib/v-calendar.umd.min.js';;

// Use v-calendar & v-date-picker components
Vue.use(VCalendar, {
  componentPrefix: 'vc',  // Use <vc-calendar /> instead of <v-calendar />
  //...,// ...other defaults
});

const schedule = new Vue({
    el: '#schedule',
    name: 'MyformSchedule',
    props: {
        editing: Boolean,
        info: Object
    },
    components:{
    },
    data () {
        return {
            schedule_dates: [],
            schedule_range: null,
            morning: [],
            noon: [],
            afternoon: [],
            morningC: [],
            noonC: [],
            afternoonC: [],
            menu: false,
            now: new Date(),
            mode: 'multiple',
            selectedDate: null,
            fecha: [new Date()],
            attributes: [
                {
                    key: 'today',
                    highlight: true,
                    dates: new Date()
                }
            ],
            attributesM: [],
            attributesN: [],
            attributesA: [],
            attributesC: [],
        }
    },
    methods: {
        alterScheduleDate(){

            var morningFormat = [];
            this.morning.forEach(element => {
                morningFormat.push(moment(element).format("YYYY-MM-DD"));
            });

            this.schedule_dates = JSON.stringify(
                morningFormat);

            this.attributesM = [
                {
                    highlight: true
                }
            ];

        },
        getSchedule(){
            
            axios.get('/schedules/get-shedule-short-stay/'+_property, {
                headers: {
                    'Content-type': 'multipart/form-data',
                }
            }).then((response) => {
                this.schedule_dates = JSON.parse(response.data.schedule_dates);
                var morningFormat = JSON.parse(response.data.schedule_dates);
                morningFormat.forEach(element => {
                    this.morning.push(moment(element)['_d']);
                    this.morningC.push(element);
                });
                
                this.attributesM = [
                    {
                        highlight: true,
                    }
                ];

                
                
            }).catch((error) => {
                console.log(error);
            });
            
        }
    },
    mounted() {
        this.getSchedule(); 
    },
    computed: {
    },
    
});





/*const _token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
import 'vuetify/dist/vuetify.min.css';

const schedule = new Vue({
    el: '#schedule',
    components : {
    },
    data() {
        return {
            morning: [],
            noon: [],
            afternoon: [],
            visit: 0,
            menu: false,
            now: new Date().toISOString().split('T')[0],
            property: document.getElementById('property_id').value
        }
    },
    methods: {
        saveSchedule(){
            const params = new FormData()
            
            params.append('_token', _token);
            params.append('morning', this.morning);
            params.append('noon', this.noon);
            params.append('afternoon', this.afternoon);

            axios.post('/schedules/save-shedule-property/'+this.property, params, {
                headers: {
                    'Content-type': 'multipart/form-data',
                }
            }).then((response) => {
                toastr.success('Se ha almacenado la información correctamente.');
                
            }).catch((error) => {
                toastr.error('Ha ocurrido un error');
            });
        },
        getSchedule(){
            axios.get('/schedules/get-shedule-property/'+this.property, {
                headers: {
                    'Content-type': 'multipart/form-data',
                }
            }).then((response) => {
                this.morning = JSON.parse(response.data.visit_from_date).morning;
                this.noon = JSON.parse(response.data.visit_from_date).noon;
                this.afternoon = JSON.parse(response.data.visit_from_date).afternoon;
                
            }).catch((error) => {
                console.log(error);
            });
        }
    },
    mounted() {
        this.getSchedule(); 
    },
})*/