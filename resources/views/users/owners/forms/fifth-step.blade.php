@extends('layouts.flujo-base')

@section('content')
<div class="container" id="third-step-page">
    <section class="section main-section">
        <div class="columns">
            <div class="column is-7 flow-form">
                <div>
                    <div class="edit-step">
                        <div>
                            <span>Paso 1</span>
                            <span>Tus datos personales</span>
                        </div>
                        <div class="edit-right">
                            <img src="{{ asset('images/icono-ok.png') }}">
                            <a href="{{ route('users.owners.first-step') }}">Editar</a>
                        </div>
                    </div>
                    <div class="edit-step">
                        <div>
                            <span>Paso 2</span>
                            <span>Configuración</span>
                        </div>
                        <div class="edit-right">
                            <img src="{{ asset('images/icono-ok.png') }}">
                            <a href="{{ route('users.owners.second-step') }}">Editar</a>
                        </div>
                    </div>
                    <div class="edit-step">
                        <div>
                            <span>Paso 3</span>
                            <span>Condiciones</span>
                        </div>
                        <div class="edit-right">
                            <img src="{{ asset('images/icono-ok.png') }}">
                            <a href="{{ route('users.owners.third-step') }}">Editar</a>
                        </div>
                    </div>
                    <div class="edit-step">
                        <div>
                            <span>Paso 4</span>
                            <span>TU arrendatario</span>
                        </div>
                        <div class="edit-right">
                            <img src="{{ asset('images/icono-ok.png') }}">
                            <a href="{{ route('users.owners.fourth-step') }}">Editar</a>
                        </div>
                    </div>

                    <h1 class="title step-title">Paso 5</h1>
                    <section class="hero main-title">
                        <div class="hero-body">
                            <div class="container">
                                <h1 class="title">Documento</h1>
                                <h1 class="title">de soporte</h1>
                            </div>
                        </div>
                    </section>
                </div>
                <div class="form-footer">
                    <a href="{{ route('users.owners.fourth-step.one') }}" class="button">Atrás</a>
                    <a href="{{ route('users.owners.fifth-step.one') }}" class="button is-outlined is-primary">Continuar</a>
                </div>
            </div>
            <div class="column side-info small">
                <div class="info small">
                    <img src="{{ asset('images/foco.png') }}">
                    <p>Todos los datos que configures</p>
                    <p>te ayudaran a encontrar</p>
                    <p>arrendatarios para tu</p>
                    <p>propiedad en menor tiempo.</p>
                    <div class="border"></div>
                </div>
            </div>
        </div>
    </section>
</div>

@endsection
