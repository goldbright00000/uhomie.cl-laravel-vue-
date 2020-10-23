@extends('layouts.flujo-base', ['navTitle' => '<span class="bold">Paso 4.1:</span> Documentos', 'close' => route('profile.owner')])
@section('content')

    <div class="container" id="own-fifth-step-one">
        <section class="section main-section">
            <div class="columns">
                <div class="column is-7 flow-form">
                    <div class="div">
                        <form method="POST" action="" enctype="multipart/form-data" id="registration-form">
                            {{ csrf_field() }}
                            
                            <h1 class="form-title">Documentos de tu propiedad <span class="form-subtitle">(Documentos formato JPG/PNG)</span></h1>
                            @if($property_type == 0)
                            @include('components.common.files', [
                                'title' => "Ultimo recibo de Luz",
                                'name' => 'last_electricity_bill',
                                'mimes' => 'image/*,application/pdf',
                                'file' => $property ? $property->files()->where('name', 'last_electricity_bill')->first() : null
                            ])
                            @include('components.common.files', [
                                'title' => "Ultimo Recibo de Agua",
                                'name' => 'last_water_bill',
                                'mimes' => 'image/*,application/pdf',
                                'file' => $property ? $property->files()->where('name', 'last_water_bill')->first() : null
                            ])
                            @include('components.common.files', [
                                'title' => "Ultimo Recibo de Gastos Comunes",
                                'name' => 'common_expense_receipt',
                                'mimes' => 'image/*,application/pdf',
                                'file' => $property ? $property->files()->where('name', 'common_expense_receipt')->first() : null
                            ])
                            @include('components.common.files', [
                                'title' => "Certificado de Propiedad o Certificado de Origen",
                                'name' => 'property_certificate',
                                'mimes' => 'application/pdf',
                                'file' => $property ? $property->files()->where('name', 'property_certificate')->first() : null
                            ])
                            @elseif($property_type == 1)
                            @include('components.common.files', [
                                'title' => "Contrato de copropiedad del edificio",
                                'name' => 'building_property_contract',
                                'mimes' => 'image/*,application/pdf',
                                'file' => $property ? $property->files()->where('name', 'building_property_contract')->first() : null
                            ])
                            @include('components.common.files', [
                                'title' => "Condiciones de habilitación de local",
                                'name' => 'property_room_conditions',
                                'mimes' => 'image/*,application/pdf',
                                'file' => $property ? $property->files()->where('name', 'property_room_conditions')->first() : null
                            ])
                            @include('components.common.files', [
                                'title' => "Reglamento del edificio / local",
                                'name' => 'regulation_rules',
                                'mimes' => 'image/*,application/pdf',
                                'file' => $property ? $property->files()->where('name', 'regulation_rules')->first() : null
                            ])
                            @elseif($property_type == 2)
                            @include('components.common.files', [
                                'title' => "Ultimo recibo de Luz",
                                'name' => 'last_electricity_bill',
                                'mimes' => 'image/*,application/pdf',
                                'file' => $property ? $property->files()->where('name', 'last_electricity_bill')->first() : null
                            ])
                            @include('components.common.files', [
                                'title' => "Ultimo Recibo de Agua",
                                'name' => 'last_water_bill',
                                'mimes' => 'image/*,application/pdf',
                                'file' => $property ? $property->files()->where('name', 'last_water_bill')->first() : null
                            ])
                            @endif
                        </div>
                        <div class="form-footer">
                            <a href="{{route('properties.fourth-step',['id' => $property->id])}}" class="button is-outlined">Atrás</a>
                            <img src="{{ asset('images/icono_guardar.png') }}" id="save-button-icon">                            <input type="submit" class="button is-outlined is-primary" value="Continuar" form="registration-form">
                        </div>
                    </div>
                    <div class="column side-info">
                        <div class="info">
                            <img src="{{ asset('images/icono-atencion.png') }}">
                            <p>Los documentos de soporte son muy</p>
                            <p>importantes, ayudan a certificar tu</p>
                            <p>propiedad y darle un mayor Scoring UHOMIE.</p>
                            <p>los arrendatarios alquilan mas rapido</p>
                            <p>cuando mas puntaje tenga tu propiedad</p>
                            <div class="border"></div>
                        </div>
                        <div class="info">
                            <img src="{{ asset('images/icono-atencion.png') }}">
                            <p>Si no posees todos los documentos no te</p>
                            <p>preocupes podras cargarlos hasta 48 horas</p>
                            <p>despues de publicado tu aviso.</p>
                            <div class="border"></div>
                        </div>
                        <div class="info">
                            <img src="{{ asset('images/icono-atencion.png') }}">
                            <p>Recuerda los documentos como Certificados de</p>
                            <p>Servicios, Luz, Agua, Gas, Internet deberan</p>
                            <p>tener maximo 30 dias de antiguedad.</p>
                            <div class="border"></div>
                        </div>
                    </div>
                </div>
            </section>
        </div>
        @include('components.users.common-forms.save-button.modal')
    @endsection

    @section('scripts')
        <script src="{{ asset('js/property-forms/four-step-one.js') }}" charset="utf-8"></script>
        <script src="{{ asset('js/third-step-three.js') }}"></script>
    @endsection
