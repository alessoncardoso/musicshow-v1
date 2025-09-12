package br.com.ifs.musicshow.dtos;

import br.com.ifs.musicshow.models.MusicaModel;

import java.util.Date;

public record MusicaDto(
        Integer id,
        Integer idUsuario,
        String titulo,
        String arquivo,
        Date dataCriacao,
        int status
) {

    public static MusicaDto fromModel(MusicaModel musicaModel) {
        return new MusicaDto(
                musicaModel.getId(),
                musicaModel.getUsuario().getId(),
                musicaModel.getTitulo(),
                musicaModel.getArquivo(),
                musicaModel.getDataCriacao(),
                musicaModel.getStatus()
        );
    }
}
