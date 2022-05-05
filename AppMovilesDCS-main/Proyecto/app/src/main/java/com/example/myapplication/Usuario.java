package com.example.myapplication;

public class Usuario
{
    private String _name;
    private String _password;
    private String _email;
    private String _phone;

    //Construnctor con todas las variables
    public Usuario(String name, String password, String email, String phone) {
        this._name = name;
        this._password = password;
        this._email = email;
        this._phone = phone;
    }
    //Constructor vacío, asocia como correo el string " "
    public Usuario() {
        this._email = "";
    }
    //Métodos getter y setter
    public String get_name() {
        return _name;
    }
    public void set_name(String _name) {
        this._name = _name;
    }
    public String get_password() {
        return _password;
    }
    public void set_password(String _password) {
        this._password = _password;
    }
    public String get_email() {
        return _email;
    }
    public void set_email(String _email) {
        this._email = _email;
    }
    public String get_phone() {
        return _phone;
    }
    public void set_phone(String _phone) {
        this._phone = _phone;
    }
}
