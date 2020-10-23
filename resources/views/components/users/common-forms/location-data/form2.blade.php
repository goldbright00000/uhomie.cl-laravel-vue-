{{ csrf_field() }}
<input type="hidden" name="latitude" value="{{$entity->latitude}}" id="latitude">
<input type="hidden" name="longitude" value="{{$entity->longitude}}" id="longitude">

<div class="field">
    <div class="label-field">
        <img src="{{ asset('images/icono_ciudad.png') }}">
        <span>Ciudad</span>
    </div>
    <div class="select">
        <select name="city" id="city" required >
            @if(is_null($entity->city_id))
              <option selected value="" disabled>Seleccione</option>
            @endif
            @foreach($cities as $city)
              <option value="{{$city->id}}" {{$entity->city_id == $city->id ? 'selected' : ''}}>{{$city->name}}</option>
            @endforeach
        </select>
    </div>
</div>

<div class="field">
    <div class="label-field">
        <img src="{{ asset('images/icono-direccion.png') }}">
        <span>Dirección</span>
    </div>
      @if( !is_null($entity) && is_a( $entity, 'App\Property' ) )
        <input type="text" class="input" name="address" id="address"  value="{{ $entity->address ? $entity->address : '' }}" autocomplete="off" required>
      @elseif( !is_null($entity) && is_a( $entity, 'App\User' ) )
        <input type="text" class="input" name="address" id="address"  value="{{ $company && $entity->getAgentCompany() ? $entity->getAgentCompany()->address : ($entity->address) ? $entity->address : '' }}" autocomplete="off" required>
      @endif
</div>
<div class="field">
    <div class="label-field">
        <img src="{{ asset('images/icono-casa.png') }}">
        <span>Casa / Apto / Piso</span>
    </div>
    @if( !is_null($entity) && is_a( $entity, 'App\Property' ) )
        <input type="text" class="input" name="address_details" id="address_details"  value="{{ $entity->address ? $entity->address_details : '' }}" autocomplete="off">
    @elseif( !is_null($entity) && is_a( $entity, 'App\User' ) )
      <input type="text" class="input" name="address_details" id="address_details"  value="{{ $company && $entity->getAgentCompany() ? $entity->getAgentCompany()->address_details : ($entity->address_details) ? $entity->address_details : '' }}" autocomplete="off">
    @endif
</div>

<div id="map"></div>

<div class="form-footer">
  <a href="{{ $back_url }}" class="button is-outlined">Atrás</a>
  <img src="{{ asset('images/icono_guardar.png') }}" id="save-button-icon">
  <input type="submit" class="button is-outlined is-primary" value="Continuar" id="btn-submit" form="registration-form" disabled="true">
</div>
