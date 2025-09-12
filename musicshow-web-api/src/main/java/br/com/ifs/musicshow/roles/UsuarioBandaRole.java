package br.com.ifs.musicshow.roles;

public enum UsuarioBandaRole {
    MUSICO("Musico"),
    MEMBRO("Membro");

    private String role;

    UsuarioBandaRole(String role) {
        this.role = role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getRole() {
        return role;
    }

}
