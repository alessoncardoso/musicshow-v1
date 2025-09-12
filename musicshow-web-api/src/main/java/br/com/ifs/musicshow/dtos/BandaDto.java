package br.com.ifs.musicshow.dtos;

import br.com.ifs.musicshow.models.BandaModel;

import java.util.Date;

public record BandaDto(
        Integer id,
        Integer idUsuario,
        String nome,
        int qtdIntegrante,
        int qtdRepertorio,
        Date dataCriacao,
        int status
) {

    public static BandaDto fromModel(BandaModel bandaModel) {
        return new BandaDto(
                bandaModel.getId(),
                bandaModel.getUsuario().getId(),
                bandaModel.getNome(),
                bandaModel.getQtdIntegrante(),
                bandaModel.getQtdRepertorio(),
                bandaModel.getDataCriacao(),
                bandaModel.getStatus()
        );
    }
}
