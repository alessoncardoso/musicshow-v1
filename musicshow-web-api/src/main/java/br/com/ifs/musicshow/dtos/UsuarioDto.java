package br.com.ifs.musicshow.dtos;

import br.com.ifs.musicshow.models.UsuarioModel;

import java.util.Date;

public record UsuarioDto(
        Integer id,
        String nome,
        String email,
        String senha,
        Date dataCriacao,
        int status
) {

    public static UsuarioDto fromModel(UsuarioModel usuarioModel) {
        return new UsuarioDto(
                usuarioModel.getId(),
                usuarioModel.getNome(),
                usuarioModel.getEmail(),
                usuarioModel.getSenha(),
                usuarioModel.getDataCriacao(),
                usuarioModel.getStatus()
        );
    }
}