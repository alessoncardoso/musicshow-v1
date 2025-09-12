package br.com.ifs.musicshow.dtos;

import br.com.ifs.musicshow.models.UsuarioBandaModel;
import java.util.Date;

public record UsuarioBandaDto(
        Integer id,
        Integer idBanda,
        Integer idUsuario,
        Date dataInclusao,
        String papelUser,
        String nome
) {

    public static UsuarioBandaDto fromModel(UsuarioBandaModel usuarioBandaModel, String nome) {
        return new UsuarioBandaDto(
                usuarioBandaModel.getId(),
                usuarioBandaModel.getBanda().getId(),
                usuarioBandaModel.getUsuario().getId(),
                usuarioBandaModel.getDataInclusao(),
                usuarioBandaModel.getPapelUser().getRole(),
                nome
        );
    }
}